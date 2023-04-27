resource "aws_vpc_peering_connection" "peering_connection" {
    peer_vpc_id     = var.vpc_id_One
    vpc_id          = var.vpc_id_two
    auto_accept     = true
    tags = {
        name        = "vpc_peering_connection"
    }
}

resource "aws_route" "vpc1-to-vpc2" {
    route_table_id              = var.route_table_one_id
    destination_cidr_block      = var.cidr_block_two
    vpc_peering_connection_id   = "${aws_vpc_peering_connection.peering_connection.id}"
}

resource "aws_route" "vpc2-to-vpc1" {
    route_table_id              = var.route_table_two_id
    destination_cidr_block      = var.cidr_block_one
    vpc_peering_connection_id   = "${aws_vpc_peering_connection.peering_connection.id}"
}