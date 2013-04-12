cgroups-eventfd-ruby
====================

Recieving cgroups events in ruby via eventmachine.

Special thanks to [Matteo Bertozzi's blog post](http://th30z.blogspot.co.uk/2011/02/linux-cgroups-memory-threshold-notifier.html)

On ubuntu this requires `cgroup-lite` installed, and needs to run as root.

For more information, read the kernel documentation 
- [Notification API in cgroups.txt](https://www.kernel.org/doc/Documentation/cgroups/cgroups.txt)
- [Cpu cgroups](https://www.kernel.org/doc/Documentation/cgroups/cpuacct.txt)
- [IO cgroups](https://www.kernel.org/doc/Documentation/cgroups/blkio-controller.txt)
