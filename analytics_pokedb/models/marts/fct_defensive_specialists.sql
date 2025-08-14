
-- models/marts/fct_defensive_specialists.sql

with pokemon_resistances as (
    -- Select the necessary columns from the staging model
    select
        pokedex_number,
        name,
        against_bug,
        against_dark,
        against_dragon,
        against_electric,
        against_fairy,
        against_fight,
        against_fire,
        against_flying,
        against_ghost,
        against_grass,
        against_ground,
        against_ice,
        against_normal,
        against_poison,
        against_psychic,
        against_rock,
        against_steel,
        against_water
    from {{ ref('stg_pokemon') }}
),

unpivoted as (
    -- This is the unpivot operation. We create a row for each attack type.
    select pokedex_number, name, 'bug' as attack_type, against_bug as effectiveness from pokemon_resistances
    union all
    select pokedex_number, name, 'dark' as attack_type, against_dark as effectiveness from pokemon_resistances
    union all
    select pokedex_number, name, 'dragon' as attack_type, against_dragon as effectiveness from pokemon_resistances
    union all
    select pokedex_number, name, 'electric' as attack_type, against_electric as effectiveness from pokemon_resistances
    union all
    select pokedex_number, name, 'fairy' as attack_type, against_fairy as effectiveness from pokemon_resistances
    union all
    select pokedex_number, name, 'fight' as attack_type, against_fight as effectiveness from pokemon_resistances
    union all
    select pokedex_number, name, 'fire' as attack_type, against_fire as effectiveness from pokemon_resistances
    union all
    select pokedex_number, name, 'flying' as attack_type, against_flying as effectiveness from pokemon_resistances
    union all
    select pokedex_number, name, 'ghost' as attack_type, against_ghost as effectiveness from pokemon_resistances
    union all
    select pokedex_number, name, 'grass' as attack_type, against_grass as effectiveness from pokemon_resistances
    union all
    select pokedex_number, name, 'ground' as attack_type, against_ground as effectiveness from pokemon_resistances
    union all
    select pokedex_number, name, 'ice' as attack_type, against_ice as effectiveness from pokemon_resistances
    union all
    select pokedex_number, name, 'normal' as attack_type, against_normal as effectiveness from pokemon_resistances
    union all
    select pokedex_number, name, 'poison' as attack_type, against_poison as effectiveness from pokemon_resistances
    union all
    select pokedex_number, name, 'psychic' as attack_type, against_psychic as effectiveness from pokemon_resistances
    union all
    select pokedex_number, name, 'rock' as attack_type, against_rock as effectiveness from pokemon_resistances
    union all
    select pokedex_number, name, 'steel' as attack_type, against_steel as effectiveness from pokemon_resistances
    union all
    select pokedex_number, name, 'water' as attack_type, against_water as effectiveness from pokemon_resistances
),

specialist_summary as (
    select
        pokedex_number,
        name,
        -- This is the standard SQL way to do a conditional count.
        -- The FILTER clause is applied to the aggregate function COUNT(*).
        count(*) filter (where effectiveness < 1) as count_of_resistances,
        count(*) filter (where effectiveness = 0) as count_of_immunities
    from unpivoted
    group by 1, 2
)

select
    *,
    rank() over (order by count_of_resistances desc, count_of_immunities desc) as defensive_rank
from specialist_summary