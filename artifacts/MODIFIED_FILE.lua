-- Transaction fixture: the changed branch is executor prefab import.
return {
	Branch = "Runtime",
	Field = "PrefabLoader",
	Value = "InsertService:LoadLocalAsset -> game:GetObjects",
}
