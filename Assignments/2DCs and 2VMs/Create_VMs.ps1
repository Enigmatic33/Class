$csvFilePath = "H:\Class\Eddy\Domain01.csv" #must be in quotes to be a string
#admin password for golden vm: P@5%w0rd!@33

# Import the CSV file into a variable
$data = Import-Csv -Path $csvFilePath

# Loop through each row in the CSV data to create VMs
foreach ($row in $data) {
# Extract the data for each VM
$vmName = DCTEST
$memory = 4GB 
$Threads = $row.Threads
$vmPath = $row.Path
$vhdxPath = $row.VHDXPath
$isoPath = $row.ISOPath
$switchName = $row.SwitchName

# Create a new VM
New-VM -Name $vmName -MemoryStartupBytes $memory -Generation 2 -VHDPath $vhdxPath -Path $vmPath 

# Set the number of processors
Set-VMProcessor -VMName $vmName -Count $Threads

# Add a network adapter and connect to the specified switch
Add-VMNetworkAdapter -VMName $vmName -SwitchName $switchName

# Start the VM
Start-VM -Name $vmName

Write-Output "Created and started VM: $vmName"
}