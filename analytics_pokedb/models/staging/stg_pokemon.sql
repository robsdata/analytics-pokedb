with source as (
    select * from {{ source('public', 'raw_pokemon') }}
),

renamed as (
    select
        "pokedex_number",
        "name",
        "type1" as primary_type,
        "type2" as secondary_type,
        "hp" as health_points,
        "attack",
        "defense",
        "sp_attack" as special_attack,
        "sp_defense" as special_defense,
        "speed",
        "base_total",
        "height_m",
        "weight_kg",
        "capture_rate",
        "base_egg_steps",
        "base_happiness",
        "percentage_male",
        "generation",
        "is_legendary",
        "classification",
        "japanese_name",
        "abilities",
        "against_bug",
        "against_dark",
        "against_dragon",
        "against_electric",
        "against_fairy",
        "against_fight",
        "against_fire",
        "against_flying",
        "against_ghost",
        "against_grass",
        "against_ground",
        "against_ice",
        "against_normal",
        "against_poison",
        "against_psychic",
        "against_rock",
        "against_steel",
        "against_water"
    from source
)

select * from renamed