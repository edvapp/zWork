#!/bin/bash

## create ANSIBLE directory & file structure

## Master directory for ansible tree
mkdir cluster
cd cluster

## directory to store different inventories and variablen files
## for different schools
mkdir inventories
cd inventories

SCHOOLS="agi app borg"

for school in $SCHOOLS;
do
	echo create directory $school
	mkdir $school
	touch $school/servers
	touch $school/clients
	
	mkdir $school/group_vars
	mkdir $school/host_vars	
done

cd ..

touch site.yml

touch nfs4server.yml
touch dhcp.yml

mkdir roles
cd roles

ROLES="common nfs4server dhcp"

for role in $ROLES;
do
	echo create directory $role
	mkdir $role
	
	mkdir $role/tasks
	touch $role/tasks/main.yml
	
	mkdir $role/handlers
	touch $role/handlers/main.yml
	
	mkdir $role/templates
	touch $role/templates/aTemplate.conf.j2
	
	mkdir $role/files
	touch $role/files/aFile.txt
	
	mkdir $role/vars
	touch $role/vars/main.yml
	
	mkdir $role/defaults
	touch $role/defaults/main.yml
	
	mkdir $role/meta
	touch $role/meta/main.yml
	
	mkdir $role/library
	
	mkdir $role/lookup_plugins
	
done
