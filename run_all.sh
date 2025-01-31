#!/bin/bash
# Check if EtherCAT service is active
# Check if EtherCAT is running
sudo /etc/init.d/ethercat start

CURRENT_BITRATE=$(ip -details -statistics link show can0 | grep -oP '(?<=bitrate )\d+')

# Check if bitrate is already set to 1000000 (1 Mbps)
if [ "$CURRENT_BITRATE" = "1000000" ]; then
    echo "CAN0 is set to 1 Mbps.."
else
    echo "Changing CAN0 bitrate to 1 Mbps..."
    
    # Bring down the interface
    sudo /usr/bin/ip link set can0 down

    # Set the bitrate
    sudo /usr/bin/ip link set can0 type can bitrate 1000000

    # Bring the interface up
    sudo /usr/bin/ip link set can0 up

    echo "CAN0 bitrate set to 1 Mbps successfully!"
fi



# Run all the scripts in sequence
cansend can0 000#8001
./txPDO1.sh
./txPDO2.sh
./rxPDO1.sh
./rxPDO2.sh
cansend can0 000#0101
echo "All scripts executed successfully!"


#halcmd setp cia402.0.fault-reset 1
#halcmd setp cia402.0.fault-reset 0


linuxcnc latheini.ini


