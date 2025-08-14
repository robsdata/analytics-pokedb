-- models/marts/fct_pokemon_efficiency.sql

with pokemon_data as (
    select
        pokedex_number,
        name,
        base_total,
        base_egg_steps,
        generation,
        is_legendary
    from {{ ref('stg_pokemon') }}
),

calculated_efficiency as (
    select
        *,
        -- By casting base_total to a numeric type, we force floating-point division.
        -- This prevents integer division where 318 / 5120 would result in 0.
        cast(base_total as numeric) / nullif(base_egg_steps, 0) as efficiency_score
    from pokemon_data
    -- We explicitly exclude legendary Pokémon as they do not follow standard breeding rules.
    where not is_legendary
),

ranked_efficiency as (
    select
        *,
        -- We use row_number() to ensure a unique rank, breaking any ties in efficiency_score.
        row_number() over (partition by generation order by efficiency_score desc nulls last) as efficiency_rank_in_generation
    from calculated_efficiency
)

-- Final selection of columns for the data mart.
select 
    pokedex_number,
    name,
    generation,
    base_total,
    base_egg_steps,
    efficiency_score,
    efficiency_rank_in_generation
from ranked_efficiency