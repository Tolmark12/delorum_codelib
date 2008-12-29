<?php
/**
 * Delorum Framework
 *
 * LICENSE
 *
 * This source file is subject to the new BSD license that is bundled
 * with this package in the file LICENSE.txt.
 * It is also available through the world-wide-web at this URL:
 * http://framework.delorum.com/license/new-bsd
 * If you did not receive a copy of the license and are unable to
 * obtain it through the world-wide-web, please send an email
 * to license@delorum.com so we can send you a copy immediately.
 *
 * @category   Delorum
 * @package    Delorum_Controller
 * @copyright  Copyright (c) 2009 Delorum Inc. (http://www.delorum.com)
 * @license    http://framework.delorum.com/license/new-bsd     New BSD License
 * @version    1.0
 */

/**
 * Custom Controller Action
 * 
 * This class is responsible for initating layout and rendering layout sequence
 * from custom controller instances.
 * 
 * This class must be extended in place of Zend_Controller_Action. After
 * extending this class in your controller instance, you must include the
 * following code in your action method:
 * <code>
 * $this->loadLayout();
 * $this->renderLayout();
 * </code>
 *
 * @category	Delorum
 * @package		Delorum_Controller
 * @author		Tyler Flint <tflint@delorum.com>
 * 
 */
class Delorum_Controller_Action extends Zend_Controller_Action
{
	
	/**
	 * Get the current route, (ie module_controller_action)
	 *
	 * @return string
	 */
    protected function _getRequestPath()
    {
    	$request = $this->getRequest();
    	return $request->getModuleName() . "_" . $request->getControllerName() . "_" . $request->getActionName();
    }
    
    /**
     * override Zend_Controller_Action::dispatch()
     *
     * @param string $action
     */
	public function dispatch($action)
    {
    	$this->_helper->resetHelpers();
    	parent::dispatch($action);
    }
    
    /**
     * Initialize layout config in Delorum_Layout
     *
     */
    public function loadLayout()
    {
    	Delorum_Layout::getInstance()->loadLayoutConfig($this->_getRequestPath());
    }
    
    /**
     * Render layout
     *
     */
    public function renderLayout()
    {
    	Delorum_Layout::getInstance()->render();
    }
    
    /**
     * Get instance of Delorum_Layout
     *
     * @return Delorum_Layout
     */
    public function getLayout()
    {
    	return Delorum_Layout::getInstance();
    }
    
}
