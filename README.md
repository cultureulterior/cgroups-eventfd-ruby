cgroups-eventfd-ruby
====================

Recieving cgroups events in ruby via eventmachine.

Special thanks to [Matteo Bertozzi's blog post](http://th30z.blogspot.co.uk/2011/02/linux-cgroups-memory-threshold-notifier.html)

On ubuntu this requires `cgroup-lite` installed, and needs to run as root.

For more information, read the kernel documentation 
- [Notification API in cgroups.txt](https://www.kernel.org/doc/Documentation/cgroups/cgroups.txt)
- [Cpu cgroups](https://www.kernel.org/doc/Documentation/cgroups/cpuacct.txt)
- [IO cgroups](https://www.kernel.org/doc/Documentation/cgroups/blkio-controller.txt)

Proposed api

```ruby
CGroup.eventfd! #enroll this process into cgroup eventfd
period = CGroup.eventfd.cpu.cfs_period_us? # read data from cgroups
CGroup.eventfd.cpu.cfs_quota_us!(0.1 * period) #hard limit group cpu to 0.1 of machine capacity
CGroup.eventfd.memory.usage_in_bytes.> 50.megabytes do #alert at 50 megabytes
  puts "too much"
end
CGroup.this.memory.usage_in_bytes.> 25.megabytes do #alert at 25 megabytes for a cgroup made of this process only
  puts "too much!"
end
```
