<!doctype html>

<!--[if lt IE 7]> <html class="no-js ie6 oldie" lang="ru"> <![endif]-->
<!--[if IE 7]>    <html class="no-js ie7 oldie" lang="ru"> <![endif]-->
<!--[if IE 8]>    <html class="no-js ie8 oldie" lang="ru"> <![endif]-->
<!--[if gt IE 8]><!--> <html class="no-js" lang="ru"> <!--<![endif]-->

<head>
	{hook run='html_head_begin'}
	
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
	
	<title>{$sHtmlTitle}</title>
	
	<meta name="description" content="{$sHtmlDescription}">
	<meta name="keywords" content="{$sHtmlKeywords}">

	{$aHtmlHeadFiles.css}
	
	<link href='http://fonts.googleapis.com/css?family=PT+Sans:400,700&subset=latin,cyrillic' rel='stylesheet' type='text/css'>

	<link href="{cfg name='path.static.skin'}/images/favicon.ico?v1" rel="shortcut icon" />
	<link rel="search" type="application/opensearchdescription+xml" href="{router page='search'}opensearch/" title="{cfg name='view.name'}" />

	{if $aHtmlRssAlternate}
		<link rel="alternate" type="application/rss+xml" href="{$aHtmlRssAlternate.url}" title="{$aHtmlRssAlternate.title}">
	{/if}

	{if $sHtmlCanonical}
		<link rel="canonical" href="{$sHtmlCanonical}" />
	{/if}

	{if $bRefreshToHome}
		<meta  HTTP-EQUIV="Refresh" CONTENT="3; URL={cfg name='path.root.web'}/">
	{/if}
	
	
	<script type="text/javascript">
		var DIR_WEB_ROOT 			= '{cfg name="path.root.web"}';
		var DIR_STATIC_SKIN 		= '{cfg name="path.static.skin"}';
		var DIR_ROOT_ENGINE_LIB 	= '{cfg name="path.root.engine_lib"}';
		var LIVESTREET_SECURITY_KEY = '{$LIVESTREET_SECURITY_KEY}';
		var SESSION_ID				= '{$_sPhpSessionId}';
		var BLOG_USE_TINYMCE		= '{cfg name="view.tinymce"}';
		
		var TINYMCE_LANG = 'en';
		{if $oConfig->GetValue('lang.current') == 'russian'}
			TINYMCE_LANG = 'ru';
		{/if}

		var aRouter = new Array();
		{foreach from=$aRouter key=sPage item=sPath}
			aRouter['{$sPage}'] = '{$sPath}';
		{/foreach}
	</script>
	
	
	{$aHtmlHeadFiles.js}

	
	<script type="text/javascript">
		var tinyMCE = false;
		ls.lang.load({json var = $aLangJs});
		ls.registry.set('comment_max_tree',{json var=$oConfig->Get('module.comment.max_tree')});
		ls.registry.set('block_stream_show_tip',{json var=$oConfig->Get('block.stream.show_tip')});
	</script>
	
	
	{if {cfg name='view.grid.type'} == 'fluid'}
		<style>
			#container {
				min-width: {cfg name='view.grid.fluid_min_width'}px;
				max-width: {cfg name='view.grid.fluid_max_width'}px;
			}
		</style>
	{else}
		<style>
			#container {
				width: {cfg name='view.grid.fixed_width'}px;
			}
		</style>
	{/if}
	
	
	{hook run='html_head_end'}
</head>
	<body>
{assign var="oBlog" value=$oTopic->getBlog()} 
{assign var="oUser" value=$oTopic->getUser()}
{assign var="oVote" value=$oTopic->getVote()} 
		<ul class="voting {if $oVote || ($oUserCurrent && $oTopic->getUserId()==$oUserCurrent->getId())|| strtotime($oTopic->getDateAdd())<$smarty.now-$oConfig->GetValue('acl.vote.topic.limit_time')}{if $oTopic->getRating()>0}positive{elseif $oTopic->getRating()<0}negative{/if}{/if} {if !$oUserCurrent || $oTopic->getUserId()==$oUserCurrent->getId() || strtotime($oTopic->getDateAdd())<$smarty.now-$oConfig->GetValue('acl.vote.topic.limit_time')}guest{/if} {if $oVote} voted {if $oVote->getDirection()>0}plus{elseif $oVote->getDirection()<0}minus{/if}{/if}">
			<li class="site-name"><a href="{cfg name='path.root.web'}" title="{cfg name='view.name'}" target="_parent">{$sSiteName}</a></li>
			<li class="plus"><a href="#" onclick="return ls.vote.vote({$oTopic->getId()},this,1,'topic');"></a></li>
			<li class="total" title="{$aLang.topic_vote_count}: {$oTopic->getCountVote()}">{if $oVote || ($oUserCurrent && $oTopic->getUserId()==$oUserCurrent->getId()) || strtotime($oTopic->getDateAdd())<$smarty.now-$oConfig->GetValue('acl.vote.topic.limit_time')} {if $oTopic->getRating()>0}+{/if}{$oTopic->getRating()} {else} <a href="#" onclick="return ls.vote.vote({$oTopic->getId()},this,0,'topic');">&mdash;</a> {/if}</li>
			<li class="minus"><a href="#" onclick="return ls.vote.vote({$oTopic->getId()},this,-1,'topic');"></a></li>
			<li class="date">{date_format date=$oTopic->getDateAdd()}</li>
			{if $oTopic->getType()=='link'}
				<li class="link"><span title="{$aLang.topic_link_count_jump}: {$oTopic->getLinkCountJump()}">{$oTopic->getLinkUrl(true)}</span></li>
			{/if}
			<li class="author"><a href="{$oUser->getUserWebPath()}" target="_parent">{$oUser->getLogin()}</a></li>
			<li class="comments-total">
				{if $oTopic->getCountComment()>0}
					<a href="{$oTopic->getUrl()}#comments" title="{$aLang.topic_comment_read}" target="_parent"><span class="red">{$oTopic->getCountComment()}</span>{if $oTopic->getCountCommentNew()}<span class="green">+{$oTopic->getCountCommentNew()}</span>{/if}</a>
				{else}
					<a href="{$oTopic->getUrl()}#comments" title="{$aLang.topic_comment_add}" target="_parent"><span class="red">{$aLang.topic_comment_add}</span></a>
				{/if}
			</li>
{if !$oUserCurrent}
<script type="text/javascript">
	jQuery(document).ready(function($){
		$('#topiclink-panel-login-form').bind('submit',function(){
			ls.user.login('topiclink-panel-login-form');
			return false;
		});
		$('#topiclink-panel-login-form-submit').attr('disabled',false);
	});
</script>
			
			<form action="{router page='login'}" id="topiclink-panel-login-form" method="post">
				<li>
					<label for="login">{$aLang.registration_login}:</label>
					<input type="text" name="login" id="login" />
				</li>
				<li>
					<label for="password">{$aLang.user_password}:</label>
					<input type="password" name="password" class="input-text" id="password" tabindex="2" />
				</li>
				<li>
					<button type="submit" name="submit_login" id="topiclink-panel-login-form-submit" disabled="disabled">{$aLang.user_login_submit}</button>
					<input type="hidden" name="return-path" value="{$PATH_WEB_CURRENT|escape:'html'}">
				</li>
			</form>
			{$PATH_WEB_CURRENT|escape:'html'}
{/if}
			<li class="close"><a href="{$oTopic->getLinkUrl()}" target="_parent">{$aLang.plugin.topiclink.close}</a></li>
			{hook run='topiclink_show_info' topic=$oTopic}
		</ul>
	</body>
</html>
