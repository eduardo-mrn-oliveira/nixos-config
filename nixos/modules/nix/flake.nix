{
	inputs,
	lib,
	...
}: let
	collectFlakeInputs = visited: input:
		if builtins.elem input visited
		then []
		else let
			children = builtins.attrValues (input.inputs or {});
		in
			[input]
			++ builtins.concatMap
			(collectFlakeInputs (visited ++ [input]))
			children;
in {
	system.extraDependencies =
		lib.unique (
			builtins.concatMap (collectFlakeInputs []) (builtins.attrValues inputs)
		);
}
