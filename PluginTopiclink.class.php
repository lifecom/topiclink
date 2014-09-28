<?php
/**
 * Plugin TopicLink
 * by Stanislav Nevolin, stanislav@nevolin.info
 */
if (!class_exists('Plugin')) {
	die('Hacking attemp!');
}
class PluginTopiclink extends Plugin {
	protected $aInherits = array(
		'action' => array('ActionLink')
	);
	public function Activate() {
		return true;
	}
	public function Init() {
		$aCSSExclude = Config::Get('head.default.css');
		$aCSSInclude = array(
			Plugin::GetTemplateWebPath(__CLASS__)."css/style.css"
		);
		$aPaths=glob(Plugin::GetPath(__CLASS__).'templates/skin/*',GLOB_ONLYDIR);		
		if (!($aPaths and in_array(Config::Get('view.skin'),array_map('basename',$aPaths)))) {
			Config::Set('head.rules.topiclink', array(
				'path'=>'___path.root.web___/link/panel/',
				'css' => array(
					'include' => $aCSSInclude,
					'exclude' => $aCSSExclude
				),
			));
		}
	}
}
?>