package
{

import flash.events.EventDispatcher;
import flash.events.IEventDispatcher;

import flexunit.framework.Assert;


/**
 * Test example.
 */
public class MainTest
{
    /**
     * Construct new MainTest.
     * Just calls parent constructor.
     */
    public function MainTest()
    {
    }

    //--------------------------------------------------------------------------
    //
    //  Public methods.
    //
    //--------------------------------------------------------------------------

    /**
     * Event dispatcher for test Objects.
     */
    protected var _eventDispatcher:IEventDispatcher = new EventDispatcher;

    [Before]
    /**
     * Init all objects before running the test.
     */
    public function setUp():void
    {
        //does nothing.
        trace("Setup test!")
    }

    [After]
    /**
     * Remove all objects after running the test.
     */
    public function tearDown():void
    {
        this._eventDispatcher = null;
        trace("Tear down test")
    }


    //--------------------------------------------------------------------------
    //
    //  Protected properties.
    //
    //--------------------------------------------------------------------------

    /**
     * Async timeout event handler (when test result never occurred).
     * Call fail of test.
     *
     * @param object Object
     */
    protected function timeoutHandler(object:Object):void
    {
        Assert.fail('Pending Event Never Occurred');
    }

    [Test]
    public function exampleTest():void
    {
        Assert.assertEquals("2x2=4", 2 * 2, 4);
    }

}

}
