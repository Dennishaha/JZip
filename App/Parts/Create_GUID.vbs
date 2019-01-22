Set TypeLib = CreateObject("Scriptlet.TypeLib")
strGUID = Left(TypeLib.Guid,38)
WScript.Echo strGUID