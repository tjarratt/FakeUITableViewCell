#import <Cedar/Cedar.h>
#import "ViewController.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(ViewControllerSpec)

describe(@"ViewController", ^{

    __block ViewController *subject;

    beforeEach(^{
        subject = [[ViewController alloc] init];
    });

    describe(@"its tableview", ^{
        beforeEach(^{
            subject.view should_not be_nil;
        });

        it(@"should have a datasource", ^{
            subject.tableView.dataSource should be_same_instance_as(subject);
        });

        it(@"should have a delegate", ^{
            subject.tableView.delegate should be_same_instance_as(subject);
        });
    });

    describe(@"its tableview cells", ^{
        __block UITableView<CedarDouble> *tableView;
        __block UITableViewCell *cell;

        beforeEach(^{
            subject.view should_not be_nil;
            
             cell = nice_fake_for([UITableViewCell class]);
//            cell = [[UITableViewCell alloc] init];

            spy_on(subject.tableView);
            tableView = (id)subject.tableView;
            
            tableView stub_method(@selector(dequeueReusableCellWithIdentifier:)).and_return(cell);
            [tableView layoutSubviews];
        });

        it(@"should get the cell from its tableview", ^{
            [subject tableView:tableView cellForRowAtIndexPath:nil] should be_same_instance_as(cell);
        });

        it(@"should have a lot of cells", ^{
            [tableView numberOfRowsInSection:0] should equal(100);
            tableView.visibleCells.count should be_greater_than_or_equal_to(5);
        });
    });
});

SPEC_END
