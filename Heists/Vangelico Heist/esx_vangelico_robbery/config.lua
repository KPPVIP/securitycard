Config = {}
Config.Locale = 'en'

Config.RequiredCopsRob = 3
Config.RequiredCopsSell = 0
Config.MinJewels = 5 
Config.MaxJewels = 20
Config.MaxWindows = 20
Config.SecBetwNextRob = 3*60*60*1000 --1 saat default baştaki 1 i 2,3 olarak değiştirirseniz 2 saat 3 saat şeklinde değişir
Config.MaxJewelsSell = 20
Config.PriceForOneJewel = 500
Config.EnableMarker = true
Config.NeedBag = false
Config.Block = 3 -- hack işemindeki zorluk
Config.Time = 30 -- hack işlemi için verilen süre
Config.HackPrice = 15000 --
Config.PoliceNotify = 80 -- hack minigameinde başarılı olsa bile gitme ihtimali (başarısız olunca hep gidiyor) 

Config.Borsoni = {40, 41, 44, 45}

Stores = {
	["jewelry"] = {
		position = { x = -629.233, y = -235.920, z = 38.057 },       
		nameofstore = "Mücevherci",
		lastrobbed = 0
	}
}