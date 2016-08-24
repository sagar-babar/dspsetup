node 'agent1.example.com' {
include roles::nginxset
include roles::mongodbset
}

node 'agent2.example.com' {
include roles::nginxset
include roles::mongodbset
}

node 'master.openstacklocal' {
include roles::mongodbset
}
