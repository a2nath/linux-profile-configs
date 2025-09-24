alias vman="sudo virt-manager"
alias vedit="sudo virsh edit"
alias veboot="sudo virsh reboot"
alias vlist="sudo virsh list --all"
alias vonsole="sudo virsh console"
alias gitclone='GIT_SSH_COMMAND="ssh -vvv" git clone'
alias vl=vlist
alias make='/usr/bin/make -j$(nproc)'
alias ll='ls -aAhlt'
alias vi=/usr/bin/vim

export vimages="/var/lib/libvirt/images"

vip() {
    local vm_name="$1"
    virsh domifaddr "$vm_name" | awk "/ipv4/ {print \$4}" | cut -d"/" -f1;
}

get_vm_list() {
    local list=$(virsh list --all | tail -n $(($(virsh list --all | wc -l)-2)))
    echo "$list"
}


vdelete() {
    if [ -n "$1" ]; then
        details=$(virsh domstats --domain "$1")
        echo -e "details--------------\n$details"

        if [[ ! "$details" =~ [Ee]rror ]]; then
        #if [[ -n "$details" ]]; then
            vm_name=$1

            echo -e "VM\n------------\n$vm_name"

            paths=$(grep "block.*path=" <<< "$details" | cut -d'=' -f2)

            echo -e "Paths\n------------\n$paths"

            # Check if any paths were found
            if [ ! -z "$paths" ]; then
                for path in $paths; do
                    if [ -f "$path" ]; then
                        echo "Deleting vdisk: $path"
                        rm "$path"
                    else
                        echo "File not found or not a regular file: $path"
                        return
                    fi
                done
                sudo virsh undefine "$1"
            else
                echo "No vdisk paths found for VM '$1'."
            fi

            echo -e "------------\ndeleted $vm_name: $(date)"
        else
            echo "VM with name \"$1\" is not found"
        fi
    fi
}


vshut() {

    vm_name=""

    if [ -n "$1" ]; then
        vm_name=$(virsh domstate $1 2>&1 | grep running)
        if [[ -n "$vm_name" ]]; then
            vm_name=$1
        fi
    else
        details_of_first="$(get_vm_list | grep running | head -1)"

        if [[ -n "$details_of_first" ]]; then
            state=$(awk "{print \$3}" <<< "$details_of_first")

            if [[ "$state" == "running" ]]; then
                vm_name=$(awk "{print \$2}" <<< "$details_of_first")
            fi
        fi
    fi

    if [[ -n "$vm_name" ]]; then

        sudo virsh shutdown "$vm_name"
        echo -e "------------\nshutting down $vm_name: $(date)"
    else
        echo "VM:$vm_name does not exist"
    fi
}


vstart() {

    vm_name=""

    if [ -n "$1" ]; then
        vm_name=$(virsh domstate $1 2>&1 | grep shut\ off)
        if [[ -n "$vm_name" ]]; then
            vm_name=$1
        fi
    else
        details_of_first="$(get_vm_list | grep shut\ off | head -1)"

        if [[ -n "$details_of_first" ]]; then
            state=$(awk "{print \$3}" <<< "$details_of_first")

            if [[ "$state" == "shut\ off" ]]; then
                vm_name=$(awk "{print \$2}" <<< "$details_of_first")
            fi
        fi
    fi

    if [[ -n "$vm_name" ]]; then

        sudo virsh start "$vm_name"
        echo -e "------------\nstarted $vm_name: $(date)"
    else
        echo "VM:$vm_name does not exist"
    fi
}

get_vm() {

    filter="$1"
    vm_name=""

    if [ -n "$2" ]; then
        vm_name=$(virsh domstate $1 2>&1 | grep $filter)
        if [[ -n "$vm_name" ]]; then
            vm_name=$2
        fi
    else
        details_of_first="$(get_vm_list | grep $filter | head -1)"

        if [[ -n "$details_of_first" ]]; then
            state=$(awk "{print \$3}" <<< "$details_of_first")

            if [[ "$state" == "$filter" ]]; then
                vm_name=$(awk "{print \$2}" <<< "$details_of_first")
            fi
        fi
    fi
}

vstart2()
{
    vm_name=$(get_vm shut\ off $1)
    if [[ -n "$vm_name" ]]; then

        sudo virsh start "$vm_name"
        echo -e "------------\nstarted $vm_name: $(date)"
    else
        echo "VM:$vm_name does not exist"
    fi
}
