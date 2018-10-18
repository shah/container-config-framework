// This is a template for the container.conf.jsonnet file that is generated
// automatically for each container.
{
	CCF_HOME : std.extVar('CCF_HOME'),
	GENERATED_ON : std.extVar('GENERATED_ON'),
	JSONNET_PATH : std.extVar('JSONNET_PATH'),

	containerName : std.extVar('containerName'),
	containerDefnHome : std.extVar('containerDefnHome'),
	containerRuntimeConfigHome : $.containerDefnHome + "/etc",

	currentUser : {
		name : std.extVar('currentUserName'),
		id : std.extVar('currentUserId'),
		groupId : std.extVar('currentUserGroupId'),
		home : std.extVar('currentUserHome')
	},
}