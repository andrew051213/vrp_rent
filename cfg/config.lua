local Config = {}

Config['Rent'] = {
    {
        carName = "Pegassi Pugio",
        carDescription = "Un anumit tip de om conduce un scuter. Esti chiar tu acel tip de persoana?",
        carPrice = 1000,
        spawnCode = "faggio",
    },
    {
        carName = "Zentorno",
        carDescription = "Zentorno, un simbol al puterii si al vitezei. Daca esti dispus sa te simti ca un rege pe drum, atunci Zentorno este masina pentru tine.",
        carPrice = 150000,
        spawnCode = "zentorno",
    }
}

Config['Npc'] = {
    ['spawnLocation'] = { x = -514.91052246094, y = -256.32006835938, z = 35.609294891357 },

    ['vehicleSpawnPoint'] = { x = -515.67358398438, y = -294.93640136719, z = 35.229511260986 },

    ['heading'] = 20
}

return {
    Config = Config
}