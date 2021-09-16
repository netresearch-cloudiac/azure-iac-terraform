from diagrams import Cluster, Diagram
from diagrams.azure.general import Resourcegroups
from diagrams.azure.compute import VM, VMWindows, VMLinux, VMImages, VMScaleSet
from diagrams.azure.network import VirtualNetworks, Firewall, LoadBalancers, Subnets, NetworkSecurityGroupsClassic
from diagrams.azure.storage import BlobStorage

# variables
rg_name = "RG-k100603-vnet"


graph_attr = {
    "fontsize": "20",
    #"bgcolor": "transparent"
}

with Diagram("Networks Scenario", show=False, graph_attr=graph_attr, filename="projectdiagram", direction="TB"):
    with Cluster("Hub"):
        #rghub = Resourcegroups(rg_name+"-hub")
        nsghubdmz = NetworkSecurityGroupsClassic("nsg_hubdmz")
        vnet1 = VirtualNetworks("vnetvdi_vnet-hub\nAddress space=172.16.0.0/16")
        vnet1 - Subnets("GatewaySubnet\n172.16.0.0/24")
        vnet1 - Subnets("commonsub\n172.16.1.0/24")
        vnet1 - Subnets("dmzsub\n172.16.2.0/24") - nsghubdmz
        vnet1 - Subnets("mgtsub\n172.16.3.0/24")
        #rghub >> vnet1

    spokerg = {}
    spokensg = {}
    spokevnet = {}

    for index in ["1", "2", "3"]:
        with Cluster("Spoke_"+index):
            #spokerg[index] = Resourcegroups(rg_name+index)
            spokensg[index] = NetworkSecurityGroupsClassic("nsg_"+index)
            spokevnet[index] = VirtualNetworks(f"vnetvdi_vnet-hub\nAddress space=10.{index}.0.0/16")
            spokevnet[index] - Subnets(f"appsub\n10.{index}.1.0/24") - spokensg[index]
            spokevnet[index] - Subnets(f"dmzsub\n10.{index}.2.0/24")
            spokevnet[index] - Subnets(f"mgtsub\n10.{index}.3.0/24")
            #spokerg[index] >> spokevnet[index]
    
    vnet1 << [spokevnet[i] for i in ["1", "2", "3"]]

     


