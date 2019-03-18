set -x

sudo -E su

# Make sure we've got Python.
apt update
apt install -y python-setuptools python-dev build-essential 
easy_install pip
pip install --upgrade virtualenv 

# Get the ansible installer, install dependencies.
git clone https://github.com/kubernetes-sigs/kubespray
cd kubespray
pip install -r requirements.txt

# Run the playbook.
ansible-playbook -i ../inventory.cfg \
    --user ubuntu \
    --become --become-user=root \
    --extra-vars "kubectl_localhost: true" \
    cluster.yml
