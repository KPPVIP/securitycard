Config = {}
Config.DrawDistance = 100.0
Config.CopsRequired = 3
Config.BlipUpdateTime = 1000
Config.CooldownTime = 20 --minutes
Config.FinishTime = 15 --minutes
Config.JammerTime = 5 --minutes
Config.JammerPrice = 5000
Config.Price = math.random(15000, 50000)

Config.Zones = {
    VehicleSpawner = {
        Pos = { x = -30.2077, y = -1106.89, z = 25.424 },
        Size = { x = 1.0, y = 1.0, z = 1.0 },
        Color = { r = 204, g = 204, b = 0 },
        Type = 1,
    },
}

Config.Tukkan = {
    Pos1 = { x = -1107.75, y = -1643.20, z = 4.6405}
}


Config.TextX = -1108.48
Config.TextY = -1643.29
Config.TextZ = 5.6

Config.NPCX = -1108.48 
Config.NPCY = -1643.29
Config.NPCZ = 3.6

Config.VehicleSpawnPoint = {
    Pos = { x = -48.0253, y = -1095.31, z = 26.422 },
    Size = { x = 3.0, y = 3.0, z = 1.0 },
    Type = -1,
}

Config.Delivery = {
    --Desert
    --Trevor Airfield 9.22KM
    Delivery1 = {
        Pos = { x = 2130.68, y = 4781.32, z = 39.87 },
        Size = { x = 3.0, y = 3.0, z = 1.0 },
        Color = { r = 204, g = 204, b = 0 },
        Type = 1,
        Payment = 22750,
        Cars = {'adder'},
    },
    --Lighthouse 9.61KM
    Delivery4 = {
        Pos = { x = 3333.51, y = 5159.91, z = 17.20 },
        Size = { x = 3.0, y = 3.0, z = 1.0 },
        Color = { r = 204, g = 204, b = 0 },
        Type = 1,
        Payment = 22750,
        Cars = {'adder'},
    },
    --House in Paleto 12.94KM
    Delivery7 = {
        Pos = { x = -437.56, y = 6254.53, z = 29.02 },
        Size = { x = 3.0, y = 3.0, z = 1.0 },
        Color = { r = 204, g = 204, b = 0 },
        Type = 1,
        Payment = 22750,
        Cars = {'adder'},
    },
    --Great Ocean Highway 10.47KM
    Delivery10 = {
        Pos = { x = -2177.51, y = 4269.51, z = 47.93 },
        Size = { x = 3.0, y = 3.0, z = 1.0 },
        Color = { r = 204, g = 204, b = 0 },
        Type = 1,
        Payment = 22750,
        Cars = {'adder'},
    },
    --Marina Drive Desert 8.15KM
    Delivery13 = {
        Pos = { x = 895.02, y = 3603.87, z = 31.72 },
        Size = { x = 3.0, y = 3.0, z = 1.0 },
        Color = { r = 204, g = 204, b = 0 },
        Type = 1,
        Payment = 22750,
        Cars = {'adder'},
    },
}