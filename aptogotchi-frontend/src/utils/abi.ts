export const ABI = {
    "address": "0xc59feff9a2007fa47077a73df6d3365f9d8bd7eb6bd81f0f6903e7c140a75113",
    "name": "main",
    "friends": [],
    "exposed_functions": [
      {
        "name": "create_accessory",
        "visibility": "public",
        "is_entry": true,
        "is_view": false,
        "generic_type_params": [],
        "params": [
          "&signer",
          "0x1::string::String"
        ],
        "return": []
      },
      {
        "name": "create_aptogotchi",
        "visibility": "public",
        "is_entry": true,
        "is_view": false,
        "generic_type_params": [],
        "params": [
          "&signer",
          "0x1::string::String",
          "u8",
          "u8",
          "u8"
        ],
        "return": []
      },
      {
        "name": "feed",
        "visibility": "public",
        "is_entry": true,
        "is_view": false,
        "generic_type_params": [],
        "params": [
          "&signer",
          "u64"
        ],
        "return": []
      },
      {
        "name": "get_aptogotchi",
        "visibility": "public",
        "is_entry": false,
        "is_view": true,
        "generic_type_params": [],
        "params": [
          "address"
        ],
        "return": [
          "0x1::string::String",
          "u64",
          "u64",
          "0xc59feff9a2007fa47077a73df6d3365f9d8bd7eb6bd81f0f6903e7c140a75113::main::AptogotchiParts"
        ]
      },
      {
        "name": "get_aptogotchi_address",
        "visibility": "public",
        "is_entry": false,
        "is_view": true,
        "generic_type_params": [],
        "params": [
          "address"
        ],
        "return": [
          "address"
        ]
      },
      {
        "name": "get_aptogotchi_collection_address",
        "visibility": "public",
        "is_entry": false,
        "is_view": true,
        "generic_type_params": [],
        "params": [],
        "return": [
          "address"
        ]
      },
      {
        "name": "has_aptogotchi",
        "visibility": "public",
        "is_entry": false,
        "is_view": true,
        "generic_type_params": [],
        "params": [
          "address"
        ],
        "return": [
          "bool"
        ]
      },
      {
        "name": "play",
        "visibility": "public",
        "is_entry": true,
        "is_view": false,
        "generic_type_params": [],
        "params": [
          "&signer",
          "u64"
        ],
        "return": []
      },
      {
        "name": "set_name",
        "visibility": "public",
        "is_entry": true,
        "is_view": false,
        "generic_type_params": [],
        "params": [
          "signer",
          "0x1::string::String"
        ],
        "return": []
      },
      {
        "name": "set_parts",
        "visibility": "public",
        "is_entry": true,
        "is_view": false,
        "generic_type_params": [],
        "params": [
          "&signer",
          "u8",
          "u8",
          "u8"
        ],
        "return": []
      },
      {
        "name": "unwear_accessory",
        "visibility": "public",
        "is_entry": true,
        "is_view": false,
        "generic_type_params": [],
        "params": [
          "&signer",
          "0x1::string::String"
        ],
        "return": []
      },
      {
        "name": "wear_accessory",
        "visibility": "public",
        "is_entry": true,
        "is_view": false,
        "generic_type_params": [],
        "params": [
          "&signer",
          "0x1::string::String"
        ],
        "return": []
      }
    ],
    "structs": [
      {
        "name": "Accessory",
        "is_native": false,
        "abilities": [
          "key"
        ],
        "generic_type_params": [],
        "fields": [
          {
            "name": "category",
            "type": "0x1::string::String"
          },
          {
            "name": "id",
            "type": "u64"
          }
        ]
      },
      {
        "name": "AptoGotchi",
        "is_native": false,
        "abilities": [
          "key"
        ],
        "generic_type_params": [],
        "fields": [
          {
            "name": "name",
            "type": "0x1::string::String"
          },
          {
            "name": "birthday",
            "type": "u64"
          },
          {
            "name": "energy_points",
            "type": "u64"
          },
          {
            "name": "parts",
            "type": "0xc59feff9a2007fa47077a73df6d3365f9d8bd7eb6bd81f0f6903e7c140a75113::main::AptogotchiParts"
          },
          {
            "name": "mutator_ref",
            "type": "0x4::token::MutatorRef"
          },
          {
            "name": "burn_ref",
            "type": "0x4::token::BurnRef"
          }
        ]
      },
      {
        "name": "AptogotchiParts",
        "is_native": false,
        "abilities": [
          "copy",
          "drop",
          "store",
          "key"
        ],
        "generic_type_params": [],
        "fields": [
          {
            "name": "body",
            "type": "u8"
          },
          {
            "name": "ear",
            "type": "u8"
          },
          {
            "name": "face",
            "type": "u8"
          }
        ]
      },
      {
        "name": "MintAptogotchiEvent",
        "is_native": false,
        "abilities": [
          "drop",
          "store"
        ],
        "generic_type_params": [],
        "fields": [
          {
            "name": "token_name",
            "type": "0x1::string::String"
          },
          {
            "name": "aptogotchi_name",
            "type": "0x1::string::String"
          },
          {
            "name": "parts",
            "type": "0xc59feff9a2007fa47077a73df6d3365f9d8bd7eb6bd81f0f6903e7c140a75113::main::AptogotchiParts"
          }
        ]
      },
      {
        "name": "ObjectController",
        "is_native": false,
        "abilities": [
          "key"
        ],
        "generic_type_params": [],
        "fields": [
          {
            "name": "app_extend_ref",
            "type": "0x1::object::ExtendRef"
          }
        ]
      }
    ]
  }