<?php
/**
 * Plugin TopicLink
 * by Stanislav Nevolin, stanislav@nevolin.info
 * This file is based on original LiveStreet ActionLink and ActionLogin code.
 */
/**
 * Обработка УРЛа вида /link/ - управление своими топиками(тип: ссылка)
 *
 */
class PLuginTopiclink_ActionLink extends PLuginTopiclink_Inherit_ActionLink {
	protected function RegisterEvent() {
		parent::RegisterEvent();
		$this->AddEvent('panel','EventPanel');
	}
	/**
	 * Переход по ссылке
	 *
	 * @return unknown
	 */
	protected function EventGo() {
		/**
		 * Получаем номер топика из УРЛ и проверяем существует ли он
		 */
		$sTopicId=$this->GetParam(0);
		if (!($oTopic=$this->Topic_GetTopicById($sTopicId)) or !$oTopic->getPublish()) {
			return parent::EventNotFound();
		}
		/**
		 * проверяем является ли топик ссылкой
		 */
		if ($oTopic->getType()!='link') {
			return parent::EventNotFound();
		}
		$this->Viewer_AddHtmlTitle($this->Lang_Get('plugin.topiclink.viewing') . ' ' . $oTopic->getLinkUrl());
		/**
		 * увелививаем число переходов по ссылке
		 */
		$oTopic->setLinkCountJump($oTopic->getLinkCountJump()+1);
		$this->Topic_UpdateTopic($oTopic);
		$this->Viewer_Assign('oTopic', $oTopic);
	}
	protected function EventPanel() {
		$sTopicId=$this->GetParam(0);
		if (!($oTopic=$this->Topic_GetTopicById($sTopicId)) or !$oTopic->getPublish()) {
			return parent::EventNotFound();
		}
		$this->Viewer_Assign('oTopic', $oTopic);
		/**
		 * Site name
		 */
		$aSiteName = explode('.', $_SERVER['SERVER_NAME']);
		$aSiteName = array_map(create_function('$sSiteNamePart', 'return  ucfirst(strtolower($sSiteNamePart));'), $aSiteName);
		//$aSiteName[count($aSiteName)-1] = "<span>" . $aSiteName[count($aSiteName)-1] . "</span>";
		$sSiteName = implode('.', $aSiteName);
		$this->Viewer_Assign('sSiteName', $sSiteName);
	}
	protected function EventLogin() {	
		/**
		 * Если нажали кнопку "Войти"
		 */
		if (isPost('submit_login') and is_string(getRequest('login')) and is_string(getRequest('password'))) {
			/**
			 * Проверяем есть ли такой юзер по логину
			 */
			if ((func_check(getRequest('login'),'mail') and $oUser=$this->User_GetUserByMail(getRequest('login')))  or  $oUser=$this->User_GetUserByLogin(getRequest('login'))) {	
				/**
				 * Сверяем хеши паролей и проверяем активен ли юзер
				 */
				if ($oUser->getPassword()==func_encrypt(getRequest('password')) and $oUser->getActivate()) {
					$bRemember=getRequest('remember',false) ? true : false;
					/**
					 * Авторизуем
					 */
					$this->User_Authorization($oUser,$bRemember);
				}
			}			
			/**
			 * Перенаправляем на страницу с которой произошла авторизация
			 */
			if (isset($_SERVER['HTTP_REFERER'])) {
				Router::Location($_SERVER['HTTP_REFERER']);
			}
			$this->Viewer_Assign('bLoginError',true);
			$this->SetTemplateAction('panel.tpl');
		}
		$this->Viewer_AddHtmlTitle($this->Lang_Get('login'));
	}
}
?>
