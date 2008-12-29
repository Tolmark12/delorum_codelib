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
 * @package    Delorum_Block
 * @copyright  Copyright (c) 2009 Delorum Inc. (http://www.delorum.com)
 * @license    http://framework.delorum.com/license/new-bsd     New BSD License
 * @version    1.0
 */

/**
 * Base Block Class
 * 
 * This class holds the core logic for all block types
 *
 * @category	Delorum
 * @package		Delorum_Block
 * @author		Tyler Flint <tflint@delorum.com>
 */
abstract class Delorum_Block_Abstract
{
	/**
	 * Unique Block Name
	 *
	 * @var string
	 */
	protected $_name;
	
	/**
	 * collection of child blocks
	 *
	 * @var array
	 */
	protected $_children	= array();

	/**
	 * Adds a child block to the child collection
	 *
	 * @param Delorum_Block_Abstract $block
	 */
	public function addChild(Delorum_Block_Abstract $block)
	{
		$this->_children[] = $block;
	}
	
	/**
	 * Removes a child block from the collection by name
	 *
	 * @param string $name
	 */
	public function removeChild($name)
	{
		for($i=0; $i<count($this->_children); $i++){
			if($this->_children[$i]->getName() == $name){
				unset($this->_children[$i]);
				return;
			}
		}
	}
	
	/**
	 * Retrieves a child instance by name
	 *
	 * @param string $name
	 * @return Delorum_Block_Abstract
	 */
	public function retrieveChild($name)
	{
		foreach($this->_children as $child){
			if($child->getName() == $name)
				return $child;
		}
		return null;
	}
	
	/**
	 * Return array of child blocks
	 *
	 * @return array
	 */
	public function retrieveChildren()
	{
		return $this->_children;
	}
	
	/**
	 * Return value of child toHtml()
	 *
	 * @param string $name
	 * @return string
	 */
	public function getChildHtml($name)
	{
		if($child = $this->retrieveChild($name))
			return $child->toHtml();
	}
	
	/**
	 * Get name
	 *
	 * @return string
	 */
	public function getName()
	{
		return $this->_name;
	}
	
	/**
	 * Set name
	 *
	 * @param string $name
	 */
	public function setName($name)
	{
		$this->_name = $name;
	}
	
	/**
	 * Returns processed html content
	 *
	 * @return string html
	 */
	public function toHtml()
	{
		return '';
	}
	
}