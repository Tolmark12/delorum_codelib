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
 * @package    Delorum_Layout
 * @copyright  Copyright (c) 2009 Delorum Inc. (http://www.delorum.com)
 * @license    http://framework.delorum.com/license/new-bsd     New BSD License
 * @version    1.0
 */

/**
 * Layout Class
 * 
 * This class is the backbone for block layouts.
 * The template files are loaded and parsed within this class.
 * The blocks are also rendered within this class also.
 * 
 * @category	Delorum
 * @package		Delorum_Layout
 * @author		Tyler Flint <tflint@delorum.com>
 */
class Delorum_Layout
{
	/**
	 * The active views directory
	 *
	 * @var string
	 */
	protected static $_viewsDir 	= '../app/views/'; //default view directory, can be overriden
	
	/**
	 * array holding list of layout.xml files, without ".xml"
	 *
	 * @var array
	 */
	protected static $_layoutFiles 	= array('page');
	
	/**
	 * Factory instance
	 *
	 * @var Delorum_Layout
	 */
	protected static $_instance;
	
	/**
	 * Reference to the root block
	 *
	 * @var Delorum_Block_Abstract
	 */
	protected $_rootBlock;
	
	public function __construct()
	{
		
	}
	
	/**
	 * Parses block and reference nodes from within layout files
	 *
	 * @param SimpleXMLElement $object
	 */
	protected function _parseConfigObject($object)
	{
		if($object){
			foreach($object->children() as $child){
				//determine node type and process accordingly
				switch($child->getName()){
					case 'block' :
						$this->_createBlockFromNode($child);
						break;
					case 'reference' :
						$this->_handleBlock($this->getBlock( (string) $child->attributes()->name, $this->_rootBlock), $child);
						break;
				}
			}
		}
	}
	
	/**
	 * Instantiate Delorum_Block, then pass on to _handleBlock.
	 * After block is handled, add block to parent.
	 *
	 * @param SimpleXMLElement 			$node
	 * @param Delorum_Block_Abstract 	$parentBlock
	 */
	protected function _createBlockFromNode($node, $parentBlock=null)
	{
		$block = $this->createBlock($node->attributes()->type);
		
		//set attributes
		foreach($node->attributes() as $attribute => $value){
			if($attribute != 'type'){
				$set = 'set' . ucfirst($attribute);
				$block->$set($value);
			}
		}
		
		$this->_handleBlock($block, $node);
		
		if(!$parentBlock)
			$this->_rootBlock = $block;
		else
			$parentBlock->addChild($block);
	}
	
	/**
	 * Responsible for manipulating a block instance.
	 *
	 * @param Delorum_Block_Abstract	$block
	 * @param SimpleXMLElement			$node
	 */
	protected function _handleBlock($block, $node)
	{
		foreach($node->children() as $child){
			switch($child->getName()){
				case 'block':
					$this->_createBlockFromNode($child, $block);
					break;
				case 'action':
					$action 	= (string) $child->attributes()->name;
					$arguments 	= array();
					foreach($child->children() as $arg){
						switch($arg->attributes()->type){
							case 'boolean' :
							case 'bool'	:
								$arguments[] = (boolean) $arg;
								break;
							case 'int' :
								$arguments[] = (int) $arg;
								break;
							case 'string' :
							default :
								$arguments[] = (string) $arg;
								break;
						}
					}
					call_user_func_array(array($block, $action), $arguments);
					break;
			}
		}
	}
	
	/**
	 * Uppercase first letter of each directory in path
	 *
	 * @param string $path
	 * @return string
	 */
	protected function _pathToUpper($path)
	{
		$pieces = explode('_', $path);
		for($i=0; $i<count($pieces); $i++){
			$pieces[$i] = ucfirst($pieces[$i]);
		}
		return implode("_", $pieces);
	}
	
	/**
	 * Creates an instance of a block depending on it's path
	 *
	 * @param string $path
	 * @return Delorum_Block_Abstract
	 */
	public function createBlock($path)
	{
		if(preg_match('/\//', $path))
			$path = preg_replace('/\//', '_block_', $path);
		$path = $this->_pathToUpper($path);
		 return new $path();
	}
	
	/**
	 * Load all registered layout files in a directory
	 *
	 * @param string $path
	 */
	public function loadLayoutConfig($path)
	{
		foreach(self::$_layoutFiles as $layout){
			$layoutFile = self::$_viewsDir . 'layout/' . $layout . '.xml';
			if(file_exists($layoutFile)){
				$xml = simplexml_load_file($layoutFile);
				//first process <default>
				$this->_parseConfigObject($xml->default);
				//now process current path
				$this->_parseConfigObject($xml->$path);
			}
		}
	}
	
	/**
	 * Initiate recursive output for block tree
	 *
	 */
	public function render()
	{
		echo $this->_rootBlock->toHtml();
	}
	
	/**
	 * Retrieve a block from the tree by name.
	 *
	 * @param string					$name
	 * @param Delorum_Block_Abstract	$parent
	 * @return Delorum_Block_Abstract
	 */
	public function getBlock($name, $parent=null)
	{
		if($name == 'root')
			return $this->_rootBlock;
		
		foreach($parent->retrieveChildren() as $child){
			if($child->getName() == $name){
				return $child;
			}else{
				$this->getBlock($name, $child);
			}
		}
	}
	
	/**
	 * Factory method to return instance
	 *
	 * @return Delorum_Layout
	 */
	public static function getInstance()
	{
		if (null === self::$_instance) {
            self::$_instance = new self();
        }

        return self::$_instance;
	}
	
	/**
	 * sets layout files to be used by layout parser
	 *
	 * @param array $files
	 */
	public static function setAdditionalLayoutFiles(array $files)
	{
		self::$_layoutFiles =  array_merge(self::$_layoutFiles, $files);
	}
	
	/**
	 * Add a layout file to be used by layout parser
	 *
	 * @param string $file
	 */
	public static function addLayoutFile($file)
	{
		array_push(self::$_layoutFiles, $file);
	}
	
	/**
	 * Sets the directory where subdirectories layout and templates are located
	 *
	 * @param string $directory
	 */
	public static function setViewsDirectory($directory)
	{
		self::$_viewsDir = $directory;
	}
	
	/**
	 * Retrieves current view directory
	 *
	 * @return string
	 */
	public static function getViewsDirectory()
	{
		return self::$_viewsDir;
	}
	
}