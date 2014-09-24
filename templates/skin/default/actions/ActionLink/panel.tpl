<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ru" xml:lang="ru">
	<head>
		<meta http-equiv="content-type" content="text/html; charset=utf-8" />
		<script type="text/javascript">
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
			var tinyMCE=false;
			var msgErrorBox = parent.msgErrorBox;	
			var msgNoticeBox = parent.msgNoticeBox;	
		</script>
		{/literal}
	</head>
	<body>
{assign var="oBlog" value=$oTopic->getBlog()} 
{assign var="oUser" value=$oTopic->getUser()}
{assign var="oVote" value=$oTopic->getVote()} 
		<ul class="voting {if $oVote || ($oUserCurrent && $oTopic->getUserId()==$oUserCurrent->getId())|| strtotime($oTopic->getDateAdd())<$smarty.now-$oConfig->GetValue('acl.vote.topic.limit_time')}{if $oTopic->getRating()>0}positive{elseif $oTopic->getRating()<0}negative{/if}{/if} {if !$oUserCurrent || $oTopic->getUserId()==$oUserCurrent->getId() || strtotime($oTopic->getDateAdd())<$smarty.now-$oConfig->GetValue('acl.vote.topic.limit_time')}guest{/if} {if $oVote} voted {if $oVote->getDirection()>0}plus{elseif $oVote->getDirection()<0}minus{/if}{/if}">
			<li class="site-name"><a href="{cfg name='path.root.web'}" title="{cfg name='view.name'}" target="_parent">{$sSiteName}</a></li>
			<li class="plus"><a href="#" onclick="lsVote.vote({$oTopic->getId()},this,1,'topic'); return false;"></a></li>
			<li class="total" title="{$aLang.topic_vote_count}: {$oTopic->getCountVote()}">{if $oVote || ($oUserCurrent && $oTopic->getUserId()==$oUserCurrent->getId()) || strtotime($oTopic->getDateAdd())<$smarty.now-$oConfig->GetValue('acl.vote.topic.limit_time')} {if $oTopic->getRating()>0}+{/if}{$oTopic->getRating()} {else} <a href="#" onclick="lsVote.vote({$oTopic->getId()},this,0,'topic'); return false;">&mdash;</a> {/if}</li>
			<li class="minus"><a href="#" onclick="lsVote.vote({$oTopic->getId()},this,-1,'topic'); return false;"></a></li>
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
			<form action="{router page='link'}login/" method="post">
				<li>
					<label for="login">{$aLang.registration_login}:</label>
					<input type="text" name="login" id="login" />
				</li>
				<li>
					<label for="password">{$aLang.user_password}:</label>
					<input type="password" name="password" class="input-text" id="password" tabindex="2" />
				</li>
				<li>
					<button type="submit">{$aLang.user_login_submit}</button>
					<input type="hidden" name="submit_login">
				</li>
			</form>
{/if}
			<li class="close"><a href="{$oTopic->getLinkUrl()}" target="_parent">{$aLang.topiclink_close}</a></li>
			{hook run='topiclink_show_info' topic=$oTopic}
		</ul>
	</body>
</html>