require 'ffi'
require 'ffi/tools/const_generator'
require "eventmachine"

module EventFD
  extend FFI::Library
  ffi_lib 'c'
  ['EFD_CLOEXEC','EFD_NONBLOCK','EFD_SEMAPHORE'].each do |const|
    const_set(const,FFI::ConstGenerator.new(nil, :required => true) do |gen|
      gen.include 'sys/eventfd.h'
      gen.const(const)
    end[const].to_i)
  end
  attach_function :eventfd, [:uint, :int], :int
end

cg = "/sys/fs/cgroup/memory/g2" 

##Make and attach current process to cgroup
File.mkdir(cg) unless File.directory?(cg)
IO.write("#{cg}/tasks",Process.pid.to_s)

##Set up watch for exceeding memory limit
limit = 200743424
mibi = IO.sysopen("#{cg}/memory.usage_in_bytes")
even = EventFD.eventfd(0, EventFD::EFD_NONBLOCK)
IO.write("#{cg}/cgroup.event_control","#{even} #{mibi} #{limit}")
efd = IO.for_fd(even,"r+b")

##Watch eventfd file descriptor in eventmachine
$lump=[]
EM.run {
  EM.add_periodic_timer(1) { print "..more memory.."; $lump << ( Array.new(10_000_000) { 0xDEADBEEF } );}
  EM.watch efd do |conn|
    class << conn
      attr_accessor :efd
      def notify_readable        
        data = @efd.read_nonblock(8).unpack('Q')[0]
        puts "notified with #{data}"
      end
    end
    conn.efd = efd
    conn.notify_readable = true
  end
}
