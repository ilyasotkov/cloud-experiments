setup() {
    check_args $@
    set_vars $@
}

set_vars() {
    env=$1
}

check_args() {
    if [[ $# -lt 1 ]]; then
        usage
    fi
    
    if [[ ! "$1" =~ ^(dev|stag|prod)$ ]]; then
        usage
    fi
}

usage() {
    set +x
    echo "Usage: $0 <ENV>"
    echo "Where ENV must be one of (dev|stag|prod)"
    exit 1
    set -x
}

terraform_init() {
    set +x
    temp_file=/tmp/terraform-init-output
    if echo '1' | TF_WORKSPACE=$1 terraform init -input=false -no-color &> $temp_file; then
        terraform workspace select $1
    else
        if cat $temp_file | grep -q 'Error: No existing workspaces.'; then
            terraform workspace new $1
            terraform init -input=false
            rm -f $temp_file
        else
            cat $temp_file
            exit 1
        fi
    fi
    set -x
}
