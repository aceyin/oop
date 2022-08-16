---
--- traits util module.
---

--- @class trait.Trait
--- @field name string trait name
--- @field suitable fun(t:trait.Trait, c:oop.Class):boolean check if current trait suit for class.
--- @field methods table<string, fun(s:oop.Object, ...:any):any>
---

return {}