<html>
	<head>
		<title>{$sHtmlTitle}</title>
		<script language="JavaScript" type="text/javascript">
var DIR_WEB_ROOT='{cfg name="path.root.web"}';
var DIR_STATIC_SKIN='{cfg name="path.static.skin"}';
var BLOG_USE_TINYMCE='{cfg name="view.tinymce"}';
var TALK_RELOAD_PERIOD='{cfg name="module.talk.period"}';
var TALK_RELOAD_REQUEST='{cfg name="module.talk.request"}'; 
var TALK_RELOAD_MAX_ERRORS='{cfg name="module.talk.max_errors"}';
var LIVESTREET_SECURITY_KEY = '{$LIVESTREET_SECURITY_KEY}';

var aRouter=new Array();
{foreach from=$aRouter key=sPage item=sPath}
aRouter['{$sPage}']='{$sPath}';
{/foreach}
</script>
		{$aHtmlHeadFiles.js}
		{$aHtmlHeadFiles.css}
{literal}
<script type="text/javascript">
var msgErrorBox=new Roar({
			position: 'upperRight',
			className: 'roar-error',
			margin: {x: 30, y: 10}
		});	
var msgNoticeBox=new Roar({
			position: 'upperRight',
			className: 'roar-notice',
			margin: {x: 30, y: 10}
		});	
</script>
{/literal}
	</head>
	<frameset rows="35, *" framespacing="0" frameborder="0">
		<frame src="{router page='link'}panel/{$oTopic->getId()}/" name="top" scrolling="no" />
		<frame src="{$oTopic->getLinkUrl()}" name="targetpage" scrolling="yes" />
	</frameset>
</html>
