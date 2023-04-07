provider "azurerm" {
  features {}
}

module "global" {
  source = "github.com/aztfmods/module-azurerm-global"

  company = "cn"
  env     = "p"
  region  = "weu"

  rgs = {
    db = { location = "westeurope" }
  }
}

module "cosmosdb" {
  source = "../../"

  company = module.global.company
  env     = module.global.env
  region  = module.global.region

  cosmosdb = {
    location           = module.global.groups.db.location
    resourcegroup      = module.global.groups.db.name
    kind               = "MongoDB"
    consistency_policy = "BoundedStaleness"

    capabilities = [
      "EnableMongo", "MongoDBv3.4",
      "EnableAggregationPipeline",
      "mongoEnableDocLevelTTL",
    ]

    geo_location = {
      weu = {
        location          = "westeurope"
        failover_priority = 0
      }
    }

    databases = {
      mongo = {
        db1 = {
          throughput = 400
          collections = {
            col1 = {
              throughput = 400
            }
          }
        }
        db2 = {
          throughput = 400
          collections = {
            col1 = {
              throughput = 400
            }
          }
        }
      }
    }
  }
  depends_on = [module.global]
}