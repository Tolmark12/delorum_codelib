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
 * Container Block
 *
 * This type of block is used solely for holding other block 
 * instances. There is no template associated with this block.
 * 
 * Calling toHtml() on this type of block will call toHtml on all
 * contained blocks, and return the output.
 * 
 * @category	Delorum
 * @package		Delorum_Block
 * @author		Tyler Flint <tflint@delorum.com>
 */
class Delorum_Block_Container extends Delorum_Block_Abstract
{
	/**
	 * Returns the html content of all containing
	 * block instances.
	 *
	 * @return string
	 */
	public function toHtml()
	{
		$html = '';
		foreach($this->_children as $child){
			$html .= $child->toHtml();
		}
		return $html;
	}
}