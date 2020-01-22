#This script inits kubernetes single node cluster by using kubeadm and pod network flannel and kubernetes web ui 

#!/bin/bash

#Install Docker for Debian
initDocker() {
	apt-get update && apt-get upgrade -y 
	apt-get install -y net-tools nfs-common thin-provisioning-tools lvm2 xfsprogs mlocate sysstat ca-certificates apt-transport-https software-properties-common 
	curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
	add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
	apt-get update
	apt-get install -y docker-ce=18.06.3~ce~3-0~debian
	sed -i 's/-H fd:\/\//-H fd:\/\/ -H tcp:\/\/0.0.0.0:2375/g' /lib/systemd/system/docker.service
}

#Install docker-compose & ctop 
initCompose() {
	sudo curl -L https://github.com/docker/compose/releases/download/1.22.0/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
	chmod 744 /usr/local/bin/docker-compose
	wget https://github.com/bcicen/ctop/releases/download/v0.7.1/ctop-0.7.1-linux-amd64 -O /usr/local/bin/ctop
	chmod +x /usr/local/bin/ctop
	systemctl daemon-reload
	systemctl restart docker
}

#Install useful packages
initPackages() {
	apt-get install -y htop tree python3-pip ntp telnet iotop jq git bwm-ng colordiff lynx curl mtr screen
	pip3 install --upgrade awscli
	apt-get update
	aws --version
}

#Install kubernetes single node cluster kubeadm with kubectl & kubelet
initKubernetes() {
	apt-get update && apt-get install -y apt-transport-https curl
	curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
	cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
	deb https://apt.kubernetes.io/ kubernetes-xenial main 
EOF
	apt-get update
	apt-get install -y kubelet kubeadm kubectl
	apt-mark hold kubelet kubeadm kubectl
}

#Initialize kubernetes cluster with specifying pod network add-on flannel
initFlannel() {
	kubeadm init --pod-network-cidr=10.244.0.0/16
	mkdir -p $HOME/.kube
	sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
	sudo chown $(id -u):$(id -g) $HOME/.kube/config
	#Flannel pod network
	kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/62e44c867a2846fefb68bd5f178daf4da3095ccb/Documentation/kube-flannel.yml
	kubectl taint nodes --all node-role.kubernetes.io/master-
}


initVoyager() {

	PROVIDER=baremetal

	curl -fsSL https://raw.githubusercontent.com/appscode/voyager/10.0.0/hack/deploy/voyager.sh \
    | bash -s -- --provider=$PROVIDER --run-on-master

    sleep 15   

}

verifyVoyager() {

	echo "Verifying whether Voyager Ingress Controller is installed successfully...."

    kubectl get pods --all-namespaces -l app=voyager

    echo "Detecting Voyager version...."

    POD_NAMESPACE=kube-system
    POD_NAME=$(kubectl get pods -n $POD_NAMESPACE -l app=voyager -o jsonpath={.items[0].metadata.name})
    kubectl exec -it $POD_NAME -n $POD_NAMESPACE voyager version
}


# initDashboard() {
# kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/master/aio/deploy/recommended/kubernetes-dashboard.yaml

# }
























































##To access dashboard by NodePort

#kubectl -n kube-system edit service kubernetes-dashboard
#expsoe KUBE_EDITOR=nano
#You should see yaml representation of the service. Change type: ClusterIP to type: NodePort and save file
#kubectl -n kube-system get service kubernetes-dashboard

#Privilage admin user and login with token
#create dashboard-admin.yml file and type text below

#apiVersion: v1
#kind: ServiceAccount
#metadata:
#  name: admin-user
#  namespace: kube-system

#create admin-user.yaml and type text below
# apiVersion: rbac.authorization.k8s.io/v1
# kind: ClusterRoleBinding
# metadata:
#   name: admin-user
# roleRef:
#   apiGroup: rbac.authorization.k8s.io
#   kind: ClusterRole
#   name: cluster-admin
# subjects:
# - kind: ServiceAccount
#   name: admin-user
#   namespace: kube-system

#Find admin-user token by typing
#kubectl -n kube-system get secret
#kubectl -n kube-system describe secret admin-user-token-frsqj





