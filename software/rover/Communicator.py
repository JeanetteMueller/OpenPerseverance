import socket
from threading import Thread

class Communicator(Thread):
    socket = 0
    target = 0

    def __init__(self, newSocket, newTarget):
        Thread.__init__(self)
        self.socket = newSocket
        self.target = newTarget
        self.daemon = True
        self.start()
    def run(self):
        while True:
            try:
                msg = self.socket.recv(2048)
            except socket.timeout as e:
                err = e.args[0]
                # this next if/else is a bit redundant, but illustrates how the
                # timeout exception is setup
                if err == 'timed out':
                    #sleep(1)
                    print('recv timed out, retry later')
                    continue
                else:
                    print(e)
                    sys.exit(1)
            except socket.error as e:
                # Something else happened, handle error, exit, etc.
                print(e)
                sys.exit(1)
            else:
                if len(msg) == 0:
                    print('orderly shutdown on server end')
                    sys.exit(0)
                else:
                    # got a message do something :)
                    self.target.parseMessage(msg)

