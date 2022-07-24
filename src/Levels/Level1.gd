extends Node2D


func _ready() -> void:
	pass


func _on_Area2D_body_entered(body: Node) -> void:
	var msg = "O usuário 123456 liberou a consquista \"pão de quejo é bom demais!\"."

	if body.is_in_group("Player"):
		JavaScript.eval(  jsFunc("alert", jsStr(msg)) )


func jsFunc(cmd: String, param: String) -> String:
	return "%s(%s);" % [cmd, param]


func jsFuncParams(cmd: String, params: Array) -> String:
	var paramsStr: String = "%s(%s" % [ cmd, str(params[0]) ]

	for i in range(1, params.size()):
		paramsStr += ", " + str(params[i])

	paramsStr += ");"

	return paramsStr


func jsStr(myStr: String) -> String:
	return "\'%s\'" % myStr
