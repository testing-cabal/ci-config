# == Class: testcabal_project::users
#
class testcabal_project::users {
  @user::virtual::localuser { 'jml':
    realname => 'Jonathan Lange',
    sshkeys  => "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAxXxpWasLT1Z3Y+42PjgHf/dzMD1e8je2cRCl2A7urWnrZP0i9Cv95elJ/t9mna5TxTe9pli8l+9GW61TG1VpO/AMtE/6IO2CI7RQxMFkugUBNY3BFExgD1RwGuMh3voIdfON63//UFB7nNAqZkybRS333CxYKGdpkoVUvw799xHAGWHg5DWztHnfLPo52x+hLgka7f1x6C/p4PucCFEop83hiPJwEskl+VSQy2iSx8Ugg0k9VDNv6pI1Hn1XiEqwUvB12s3Zh/AtPVOtxhQPhB6XeupRQ4ZW4D1EGmPYhjl6TDzb5VuqQUhh1CjwF15L3mh8HbAGZ7FWZB2q/8qHBw== jml@truth\n",
  }

  @user::virtual::localuser { 'robertc':
    realname => 'Robert Collins',
    sshkeys  => "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDg/kUthl0Em5IEKGQpRYq7Yp5n1aoelJDEi5KzAvvevhCUEzlmgZI/y6cfixSC5ZJpFydZ+FlSDMiFbUwXmzHCSuEteFDtiaFpF+8E5+g7lgvjl0lJ/kWGZEGe9R00lsD9Xj0G1SZXClijS/yFDdpm9Gb2JfCUiruzW2Tu7LkOAdmAwcHw2MrZPMfuPzLFnP/aex1FfokCz+35pgi4EK98znigN5l8XyMG7/wP07WeTUY82lW6ea7bR8X8G9VH+G7iqtwftxpzT+HQJ9+CIK+y1BucGsM6uYTB3aC9bVuUMKVmHpTuLXmKTaAt4rouvGFcHmOFtd6KGqUEFcFqyCij robertc@lifelesshp\n",
  }

}
