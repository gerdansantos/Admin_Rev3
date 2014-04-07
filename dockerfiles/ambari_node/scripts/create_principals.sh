#!/bin/sh

#export p_file="/root/conf/principals.csv"

##########################################
#		            Functions
##########################################

function create_principals {

   echo "Please enter CSV file name with absoulte path: "
   read p_file
  
   mkdir -p p_output/node1
   mkdir -p p_output/node2
   mkdir -p p_output/node3
   mkdir -p p_output/node4


   while read cur_p
   do

echo "\"$cur_p\""

     node=`echo "$cur_p" | cut -d"," -f1`
     principal=`echo \"$cur_p\" | cut -d',' -f3`
     kt_file=`echo "$cur_p" | cut -d"," -f4`
     dir=`echo "$cur_p" | cut -d',' -f5`
     owner=`echo "$cur_p" | cut -d"," -f6`
     group=`echo "$cur_p" | cut -d"," -f7`
     perm=`echo "$cur_p" | cut -d"," -f8`

     echo "$kt_file -- $owner -- $group -- $perm -- $node -- $principal -- $dir"


     ssh -o StrictHostKeyChecking=no -f root@$node mkdir -p /etc/security/keytabs
     ssh -o StrictHostKeyChecking=no -f root@$node chown root:hadoop /etc/security/keytabs
     ssh -o StrictHostKeyChecking=no -f root@$node chmod 755 /etc/security/keytabs


     echo "-------------------------------------"
     echo "creating principal for the line: {$cur_p}....."
     echo
  
     /usr/sbin/kadmin.local -q "addprinc -randkey $principal"
     /usr/sbin/kadmin.local -q "xst -norandkey -k p_output/$node/$kt_file $principal"           
 
     scp p_output/$node/$kt_file root@$node:/etc/security/keytabs/

     ssh -o StrictHostKeyChecking=no -f root@$node chown $owner:$group /etc/security/keytabs/$kt_file
     ssh -o StrictHostKeyChecking=no -f root@$node chmod $perm /etc/security/keytabs/$kt_file
 
  done < $p_file
}
 rm -rf p_output

##########################################
#		            MAIN
##########################################

create_principals

