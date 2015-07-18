Callback Locker
===============

"Locker" is lockable box for equipment -- at this case box for
collecting the callbacks (in its locked state) and running them
after unlocking. So, in fact, it serves as some kind of callback
semaphore or mutex.

Some trivial example:

```ruby
require "callback-locker"
locker = CallbackLocker::new

foo = nil
locker.synchronize do
    foo = "bar"
end

# ^^^ locker is unlocked, so #synchronize will execute callback
#     immediately

foo = nil
locker.lock!
locker.synchronize do
    foo = "1"
end
locker.synchronize do
    foo << "2"
end
locker.unlock!

# ^^^ locker is locked, so callbacks are stacked and executed
#     immediately after the #unlock! method is call, so foo
#     will contain "12"
```

Copyright
---------

Copyright &copy; 2011 &ndash; 2015 [Martin Poljak][10]. See `LICENSE.txt` for
further details.

[8]: http://rubyeventmachine.com/
[9]: http://github.com/martinkozak/callback-adapter/issues
[10]: http://www.martinpoljak.net/
