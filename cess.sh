#!/bin/bash
# 节点安装功能
function install_node() {

	sudo apt update

	sudo apt install apt-transport-https ca-certificates curl software-properties-common

	echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
 	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

 	sudo apt update
    sudo apt install docker-ce docker-ce-cli containerd


	# 验证 Docker Engine 安装是否成功
	sudo docker run hello-world
	# 应该能看到 hello-world 程序的输出

	# 检查 Docker Compose 版本
	docker-compose -v
	
	# 检查 Git 是否已安装
	if ! command -v git &> /dev/null
	then
	    # 如果 Git 未安装，则进行安装
	    echo "未检测到 Git，正在安装..."
	    sudo apt install git -y
	else
	    # 如果 Git 已安装，则不做任何操作
	    echo "Git 已安装。"
	fi

	# 安装cess节点
	wget https://github.com/CESSProject/cess-nodeadm/archive/v0.5.5.tar.gz
	tar -xvzf v0.5.5.tar.gz
	cd cess-nodeadm-0.5.5/ && ./install.sh

}

# 节点配置
function config_node() {
	# 设置testnet
	sudo cess profile testnet
	
	sudo cess config set
}

# 启动节点
function start_node() {
	sudo cess start
}

# Check CESS Chain Sync Status
function check_cess_chain_sync_status() {
	docker logs chain
}

# View the Storage Node Log
function view_storage_node_log() {
	docker logs bucket
}

# View Bucket Status
function view_bucket_status() {
	sudo cess bucket stat
}


# 主菜单
function main_menu() {
    clear
    echo "1. 安装节点"
    echo "2. 配置节点"
    echo "3. 启动节点"
    echo "4. Check CESS Chain Sync Status"
    echo "5. View the Storage Node Log"
    echo "6. View Bucket Status"
    read -p "请输入选项（1-6）: " OPTION

    case $OPTION in
    1) install_node ;;
    2) config_node ;;
    3) start_node ;;
    4) check_cess_chain_sync_status ;;
    5) view_storage_node_log ;;
    6) view_bucket_status ;;
    *) echo "无效选项。" ;;
    esac
}

# 显示主菜单
main_menu