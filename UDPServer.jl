# ====================================
# UDPServer.jl
# ====================================
import Dates
using Sockets
# Note: "192.168.1.155" is your local localhost
# port # must be the same for Sender/Receiver

function UDPSocketReceive()
    s = Sockets.UDPSocket()
    bd = bind(s,IPv4("108.45.74.192"),11028)
    #bd = bind(s,IPv4("192.168.1.155"),11028)
    if( !bd ) 
        println("fails to bind local socket address....", bd)
        exit()
    else
        while true
            t = Dates.now()
            println("UDPServer receiving data.... ", Dates.format(t, "yyyy-mm-dd at HH:MM:SS")  )
            hostport, packet = Sockets.recvfrom(s)
            println(packet)
        end
    end 
end

UDPSocketReceive()