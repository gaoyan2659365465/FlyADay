@tool
extends EditorPlugin


var export_plugin : AndroidExportPlugin

func _enter_tree():
	export_plugin = AndroidExportPlugin.new()
	add_export_plugin(export_plugin)


func _exit_tree():
	remove_export_plugin(export_plugin)
	export_plugin = null


class AndroidExportPlugin extends EditorExportPlugin:
	var _plugin_name = "AndroidGameTool"

	func _supports_platform(platform):
		if platform is EditorExportPlatformAndroid:
			return true
		return false

	func _get_android_libraries(platform, debug):
		if debug:
			return PackedStringArray([
			"android_game_tool/androidgametool-debug.aar",
			"android_game_tool/libs/csj_ad_sdk_230215.aar",
			"android_game_tool/libs/gdt_ad_sdk_230210.aar",
			"android_game_tool/libs/pocket_ad_sdk_3.2.8.aar",
			"android_game_tool/libs/ks_ad_sdk_230116.aar",])
		else:
			return PackedStringArray([
			"android_game_tool/androidgametool-release.aar",
			"android_game_tool/libs/csj_ad_sdk_230215.aar",
			"android_game_tool/libs/gdt_ad_sdk_230210.aar",
			"android_game_tool/libs/pocket_ad_sdk_3.2.8.aar",
			"android_game_tool/libs/ks_ad_sdk_230116.aar",])

	func _get_android_dependencies(platform: EditorExportPlatform, debug: bool) -> PackedStringArray:
		return PackedStringArray(["com.squareup.okhttp3:okhttp:4.9.2","com.google.code.gson:gson:2.8.8","androidx.legacy:legacy-support-core-ui:1.0.0","io.noties.markwon:core:4.6.2","io.noties.markwon:html:4.6.2","androidx.appcompat:appcompat:1.6.1","com.google.android.material:material:1.9.0","androidx.constraintlayout:constraintlayout:2.1.4"])

	func _get_android_dependencies_maven_repos(platform: EditorExportPlatform, debug: bool) -> PackedStringArray:
		return PackedStringArray([
			"https://jitpack.io",
		])
	
	func _get_android_manifest_application_element_contents(platform: EditorExportPlatform, debug: bool) -> String:
		return """
		<activity 
		android:name="com.example.androidgametool.PrivacyPolicyActivity" 
		android:theme="@style/Theme.MaterialComponents.NoActionBar" 
		android:exported="true" 
		tools:replace="android:exported"
		android:screenOrientation="portrait"
		>
			<intent-filter>
				<action android:name="android.intent.action.MAIN" />
				<category android:name="android.intent.category.DEFAULT" />
				<category android:name="android.intent.category.LAUNCHER" />
			</intent-filter>
		</activity>
		"""
	
	func _get_android_manifest_element_contents(platform: EditorExportPlatform, debug: bool) -> String:
		return """
	<uses-permission android:name="android.permission.INTERNET"/>
	<uses-permission android:name="android.permission.WAKE_LOCK"/>
	<uses-permission android:name="android.permission.GET_TASKS"/>
	<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>
	<uses-permission android:name="android.permission.ACCESS_WIFI_STATE"/>
	<uses-permission android:name="android.permission.REQUEST_INSTALL_PACKAGES"/>
	
	<uses-permission android:name="android.permission.READ_PHONE_STATE"/>
	<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
	<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
	<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
	<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
	"""

#<uses-permission android:name="android.permission.READ_PHONE_STATE"  tools:node="remove"/>
#<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"  tools:node="remove"/>
#<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"  tools:node="remove"/>
#<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"  tools:node="remove"/>
#<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"  tools:node="remove"/>


#<uses-permission android:name="android.permission.READ_PHONE_STATE" />
#<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
#<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
#<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
#<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />

	
	func _get_name():
		return _plugin_name
