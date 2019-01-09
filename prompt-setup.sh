#!/bin/bash
#
# /etc/prompt-setup -or- $HOME/.prompt-setup
# This script customizes the PS1 and PS2 variables
# based on the current user and distro.
# Easily readable and consequently modifiable.
#
# Written by nootmuskaat


determine_distro() {
    local -l distro
    local -r os_release="/etc/os-release"
    if [ -r $os_release ]; then
        if grep -qi 'centos' $os_release    ; then distro='centos' ;
        elif grep -qi 'red hat' $os_release ; then distro='redhat' ;
        elif grep -qi 'suse' $os_release    ; then distro='suse' ;
        elif grep -qi 'ubuntu' $os_release  ; then distro='ubuntu' ;
        elif grep -qi 'debian' $os_release  ; then distro='debian' ;
        elif grep -qi 'arch' $os_release    ; then distro='arch' ;
        else                                       distro='unknown' ;
        fi
    else
        if [[ -e /etc/centos-release ]]     ; then distro='centos' ;
        elif [[ -e /etc/redhat-release ]]   ; then distro='redhat' ;
        elif [[ -e /etc/SuSE-release ]]     ; then distro='suse' ;
        elif [[ -e /etc/ubuntu-release ]]   ; then distro='ubuntu' ;
        elif [[ -e /etc/debian_version ]]   ; then distro='debian' ;
        else  distro='unknown' ;
        fi
    fi
    echo "${distro}"
}


set_ps1_and_2() {
    local -r distro="$1"
    local -ir uid="$2"
    # formats
    local -r root_ps1='\h:\w #'
    local -r root_ps2='# >'
    local -r u='\u'
    local -r user_ps1='@\h:\w \$'
    local -r user_ps2='$ >'
    local -r end='\[\e[m\] '
    # colors
    local -r red='\[\e[31m\]'
    local -r grn='\[\e[32m\]'
    local -r ylw='\[\e[33m\]'
    local -r blu='\[\e[34m\]'
    local -r mag='\[\e[35m\]'
    local -r cyn='\[\e[36m\]'
    local -r wht='\[\e[37m\]'
    local -r blk_on_red='\[\e[30;41m\]'
    local -r blk_on_grn='\[\e[30;42m\]'
    local -r blk_on_ylw='\[\e[30;43m\]'
    local -r blk_on_blu='\[\e[30;44m\]'
    local -r blk_on_mag='\[\e[30;45m\]'
    local -r blk_on_cyn='\[\e[30;46m\]'
    local -r blk_on_wht='\[\e[30;47m\]'

    local host_color user_color
    case "$distro" in
        "centos"|"fedora")
            host_color="ylw" ;;
        "redhat")
            host_color="red" ;;
        "suse")
            host_color="grn" ;;
        "debian"|"ubuntu")
            host_color="mag" ;;
        "arch")
            host_color="cyn" ;;
        *)
            host_color="wht" ;;
    esac
    case "$host_color" in
        "ylw"|"")
            user_color="red" ;;
        *)
            user_color="ylw" ;;
    esac

    local ps1 ps2 negative
    if [[ $uid == 0 ]] ; then
        negative="blk_on_${host_color}"
        ps1="${!negative}$root_ps1"
        ps2="${!negative}$root_ps2"
    else
        ps1="${!user_color}${u}${!host_color}${user_ps1}"
        ps2="${!host_color}${user_ps2}"
    fi
    export PS1="${ps1}${end}"
    export PS2="${ps2}${end}"
}


main() {
    local -r distro="$(determine_distro)"
    set_ps1_and_2 "$distro" "$UID"
}

main
