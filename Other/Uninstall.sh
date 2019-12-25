# !/bin/bash

plugin_name="DingTalkMacPlugin"
app_name="DingTalk"
app_chinese_name="钉钉"

app_path="/Applications/${app_name}.app"

if [ ! -d "$app_path" ]; then
  app_path=${HOME}${app_path}
  if [ ! -d "$app_path" ]; then
    app_path="/Applications/${app_chinese_name}.app"
    if [ ! -d "$app_path" ]; then
      app_path=${HOME}${app_path}
      if [ ! -d "$app_path" ]; then
        echo -e "\n\n未发现${app_chinese_name}，请检查${app_chinese_name}是否有重命名或者移动路径位置"
        exit
      fi
    fi
  fi
fi

app_frameworks_path="${app_path}/Contents/Frameworks"
plugin_path="${app_frameworks_path}/${plugin_name}.framework"
app_bundle_path="${app_path}/Contents/MacOS"
app_executable_path="${app_bundle_path}/${app_name}"
app_executable_backup_path="${app_executable_path}_backup"

if [ -f "$app_executable_backup_path" ]
then
	rm "$app_executable_path"
	rm -rf "$plugin_path"
	mv "$app_executable_backup_path" "$app_executable_path"

	if [ -f "$app_executable_backup_path" ]; then
		echo "卸载失败，请到 ${app_frameworks_path} 路径，删除 ${plugin_name}.framework，${app_bundle_path} 路径，删除 ${app_name} ，并将 ${app_name}_backup 重命名为 ${app_name}"
	else
		echo "卸载成功"
	fi

else
	echo "未发现插件"
fi
