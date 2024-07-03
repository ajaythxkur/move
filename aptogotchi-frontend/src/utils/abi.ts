export const ABI = {
    "address": "0x301aceaef4cf3e041f5163893efc4d1895fc0a5d9cc38eb3aa98f27df2c83787",
    "name": "main",
    "friends": [],
    "exposed_functions": [
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
        }
    ],
    "structs": [
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
                    "type": "0x301aceaef4cf3e041f5163893efc4d1895fc0a5d9cc38eb3aa98f27df2c83787::main::AptogotchiParts"
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
                    "type": "0x301aceaef4cf3e041f5163893efc4d1895fc0a5d9cc38eb3aa98f27df2c83787::main::AptogotchiParts"
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