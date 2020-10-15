#!/bin/bash

plugin_name="DingTalkMacPlugin"
app_name="DingTalk"
app_chinese_name="钉钉"
grep_name="[D]ingTalk"
zip_folder="/tmp"

app_path="/Applications/${app_name}.app"
zip_path="${zip_folder}/${plugin_name}"

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

version_file=${app_path}/Contents/MacOS/${plugin_name}.framework/Resources/Info.plist


open_app() {
  is_app_running=$(ps aux | grep ${grep_name}.app | wc -l)
  if [ -n "$installed" ] && [ $is_app_running != "0" ]; then
    echo 检测到${app_chinese_name}正在运行，请重启${app_chinese_name}让插件生效。
  else
    echo 打开${app_chinese_name}
    open $app_path
  fi
}

# 下载插件
download_plugin() {
  installed="y"
  _version=$1
  echo 开始下载插件 v${_version}……
  # 下载压缩包
  curl -L -o ${zip_path}.zip https://github.com/TozyZuo/${plugin_name}/releases/download/v${_version}/${plugin_name}.zip
  if [ 0 -eq $? ]; then
    # 解压为同名文件夹
    unzip -o -q ${zip_path}.zip -d ${zip_folder}
    # 删除压缩包
    rm ${zip_path}.zip
    echo 下载完成
  else
    echo 下载失败，请稍后重试。
    exit 1
  fi
  echo 开始安装插件……
  ${zip_path}/Install.sh
  rm -rf ${zip_path}
  echo 插件安装完成。
  open_app
}

# 获取当前版本
if [ -f $version_file ]; then
  current_version=$(/usr/libexec/PlistBuddy -c "Print CFBundleShortVersionString" $version_file)
  current_version=${current_version//$'\r'/}
  echo 当前插件版本为 v${current_version}
fi

if [ -z $latest_version ]; then
  echo 正在检查新版本……
  latest_version=$(curl -I -s https://github.com/TozyZuo/${plugin_name}/releases/latest | grep location | sed -n 's/.*\/v\(.*\)/\1/p')
  if [ -z "$latest_version" ]; then
    echo 检查新版本时失败
  else
    latest_version=${latest_version//$'\r'/}
    echo 最新插件版本为 v${latest_version}
    if [[ $current_version < $latest_version ]]; then
      download_plugin $latest_version
    else
      echo 当前已是最新版本。
    fi
  fi
fi
