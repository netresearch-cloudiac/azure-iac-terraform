from diagrams import Cluster, Diagram
from diagrams.azure.general import Resourcegroups
from diagrams.azure.compute import VM, VMWindows, VMLinux, VMImages, VMScaleSet
from diagrams.azure.network import VirtualNetworks, Firewall, LoadBalancers
from diagrams.azure.storage import BlobStorage

graph_attr = {
    "fontsize": "20",
    #"bgcolor": "transparent"
}

with Diagram("IaaS", show=False, graph_attr=graph_attr, filename="projectdiagram", direction="LR"):
    with Cluster("RG"):
        Resourcegroups("RG-APP01")

        lb = LoadBalancers("LB_APP01")


        with Cluster("Web Cluster"):
            webclus = [VM("web01"), 
            VMWindows("web02"),
            VMLinux("web03")]

        with Cluster("DB Cluster"):
            dbclus = [VM("db01"), VM("db02")]
    
    with Cluster("FW"):
        Resourcegroups("RG-Hub")
        fw = Firewall("AzFW01")

        #lb >> fw
    fw >> lb
    lb >> webclus >> BlobStorage("Web Backup")
    lb >> dbclus >> BlobStorage("Db Backup")

    # Firewall("AzFW01") >> LoadBalancers("LB_APP01") >> VM("web01")
    # Firewall("AzFW01") >> LoadBalancers("LB_APP01") >> VM("web02")

    # Resourcegroups("RG-test")