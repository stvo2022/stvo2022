# ====================================
# UDPSender.jl
# ====================================
import Dates
using Sockets
sock = UDPSocket()

data = [0x00, 0x20, 0x00, 0x10, 0x00, 0x01, 0x00, 0x3f, 0x00, 0x08, 0x00, 0x00, 0x0b, 0xb8, 0x64, 0x00]


for n in 1:100
    t = Dates.now()
    println("UDPSender sending data.... ", Dates.format(t, "yyyy-mm-dd at HH:MM:SS")  )
    status = send(sock,ip"108.45.74.192", 11028,data)
    sleep(10)
end
close(sock)
exit()