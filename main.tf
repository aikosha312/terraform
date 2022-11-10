# calling module from .modules/vpc to create vpc:
module "hw1_vpc" {
    source = "./modules/vpc"
    cidr = "10.0.0.0/24"
}

# calling module from my macbook to create public subnets:
module "hw1_public_subnets" {
    source = "/Users/russgazin/Desktop/public_subnets"
    cidr_block = ["10.0.0.0/26", "10.0.0.64/26"]
    vpc_id     = module.hw1_vpc.rustem
}

# calling module from ./modules/private_subnets to create private subnets:
module "hw1_private_subnets" {
    source = "./modules/private_subnets"
    cidr_block = ["10.0.0.128/26", "10.0.0.192/26"]
    vpc_id     = module.hw1_vpc.rustem
}

# create igw:
module "hw1_igw" {
    source = "./modules/igw"
    vpc_id = module.hw1_vpc.rustem
}

# create natgw:
module "hw1_natgw" {
  source    = "./modules/natgw"
  subnet_id = module.hw1_public_subnets.public_subnet_id[0]
}

# create public rtb:
module "public_route_table" {
  source = "./modules/public_rtb"
  vpc_id = module.hw1_vpc.rustem
  igw_id = module.hw1_igw.igw_id
}

# assoc public rtb with public subnets:
module "rtb_public_subnet_association" {
  source         = "./modules/rtb_assoc"
  subnet_id      = [module.hw1_public_subnets.public_subnet_id[0], module.hw1_public_subnets.public_subnet_id[1]]
  route_table_id = module.public_route_table.public_route_table_id
}

# create route table for private subnets, route www traffic to natgw:
module "private_route_table" {
  source   = "./modules/private_rtb"
  vpc_id   = module.hw1_vpc.rustem
  natgw_id = module.hw1_natgw.natgw_id
}

# assoc private rtb with private subnets:
module "rtb_private_subnet_association" {
  source         = "./modules/rtb_assoc"
  subnet_id      = [module.hw1_private_subnets.private_subnet_id[0], module.hw1_private_subnets.private_subnet_id[1]]
  route_table_id = module.private_route_table.private_route_table_id
}
