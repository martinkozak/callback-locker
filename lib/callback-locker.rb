# encoding: utf-8
# (c) 2011 Martin Kozák (martinkozak@martinkozak.net)

##
# Runs or defers callbacks according to its internal locked
# or unlocked state.
#

class CallbackLocker
  
    ##
    # Indicates locker is locked.
    # @returns [Boolean] +true+ if it's, +false+ otherwise
    #
    
    @locked
    
    ##
    # Indicates, locker is just in synchronization state, 
    # so stack of callbacks is evaluated just now.
    #
    # @returns [Boolean] +true+ if it's, +false+ otherwise
    #
    
    @syncing
    
    ##
    # Holds callback stack.
    # @return [Array]  array of callbacks
    #
    
    attr_accessor :stack
    @stack
    
    ##
    # Constructor.
    #
    
    def initialize
        @syncing = false
        @locked = false
        @stack = [ ]
    end

    ##
    # Locks the locker. Note, it's also alias for 
    # {#try_lock} which is multiple pass-in so sets 
    # lock although it's locked. 
    #
    
    def lock
        @locked = true
    end
    
    alias :try_lock :lock
    alias :lock! :lock
    alias :try_lock! :try_lock
    
    ##
    # Unlocks the locker.
    #
    
    def unlock
        @locked = false
        self.eval!
    end
    
    alias :unlock! :unlock
    
    ##
    # Indicates, locker is locked.
    # @return [Boolean] +true+ if it's, +false+ otherwise
    #
    
    def locked?
        @locked
    end
    
    ##
    # Indicates, locker is unlocked.
    # @return [Boolean] +true+ if it's, +false+ otherwise
    #
    
    def unlocked?
        not self.locked?
    end
        
    ##
    # Synchronizes using the lock. Works by similiar 
    # way as standard +Mutex#synchronize+.
    #
    # @yield if locker is unlocked the given callback
    #
    
    def synchronize(&block)
        if self.locked? or @syncing
            @stack << block
        else
            @syncing = true
            yield
            @syncing = false
            
            if not @stack.empty?
                self.eval!
            end
        end
    end
    
    
    ##
    # Evals the stack.
    #

    protected    
    def eval!
        @syncing = true
        @stack.each { |b| b.call() }
        @stack.clear()
        @syncing = false        
    end

end

