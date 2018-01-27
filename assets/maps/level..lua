return {
  version = "1.1",
  luaversion = "5.1",
  tiledversion = "1.1.0",
  orientation = "orthogonal",
  renderorder = "left-up",
  width = 15,
  height = 15,
  tilewidth = 16,
  tileheight = 16,
  nextobjectid = 1,
  properties = {},
  tilesets = {
    {
      name = "map",
      firstgid = 1,
      filename = "../../../../map.tsx",
      tilewidth = 16,
      tileheight = 16,
      spacing = 0,
      margin = 0,
      image = "../img/map_spritesheet.png",
      imagewidth = 48,
      imageheight = 64,
      tileoffset = {
        x = 0,
        y = 0
      },
      grid = {
        orientation = "orthogonal",
        width = 16,
        height = 16
      },
      properties = {},
      terrains = {},
      tilecount = 12,
      tiles = {}
    }
  },
  layers = {
    {
      type = "tilelayer",
      name = "walls",
      x = 0,
      y = 0,
      width = 15,
      height = 15,
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {
        ["isSolid"] = true
      },
      encoding = "lua",
      data = {
        10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10,
        10, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 3, 10,
        10, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 6, 10,
        10, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 6, 10,
        10, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 6, 10,
        10, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 6, 10,
        10, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 6, 10,
        10, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 6, 10,
        10, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 6, 10,
        10, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 6, 10,
        10, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 6, 10,
        10, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 6, 10,
        10, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 6, 10,
        10, 7, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 9, 10,
        10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10
      }
    },
    {
      type = "tilelayer",
      name = "floor",
      x = 0,
      y = 0,
      width = 15,
      height = 15,
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      encoding = "lua",
      data = {
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 0, 0,
        0, 0, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 0, 0,
        0, 0, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 0, 0,
        0, 0, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 0, 0,
        0, 0, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 0, 0,
        0, 0, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 0, 0,
        0, 0, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 0, 0,
        0, 0, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 0, 0,
        0, 0, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 0, 0,
        0, 0, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 0, 0,
        0, 0, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
      }
    }
  }
}