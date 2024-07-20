import { LightningElement, api, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';

export default class RichTextField extends LightningElement {
    @api recordId;
    @api objectApiName;
	@api fieldName;
	@api richTextContent;
	theRecord;
	error;

	get recordFieldName() {
		// console.log( [ this.objectApiName + "." + this.fieldName ] );
		return [ `${this.objectApiName}.${this.fieldName}` ];
	}

    @wire( getRecord, { recordId: '$recordId', fields: '$recordFieldName' } )
        retrieveRecord( result ) {
            // NOTE:  this will run twice, the first time recordId will not be set
            if( ! this.recordId ) {
                return;
            }

            // console.log( 'recordId', this.recordId );
            
            if( result && result.error ) {
				this.reportError( result.error );
                return;
            }
            if( result ) {
                console.log( 'retrieved Record', JSON.stringify( result ) );
                this.theRecord = result;
            }
        };
	
	reportError( error ) {
		console.log( 'error', JSON.stringify( error ) );
		if( error.body && error.body.message ) {
			this.error = error.body.message;
		} else {
			this.error = error;
		}
	}

	get richTextValue() {
		try {
			if( this.richTextContent ) {
				return this.richTextContent;
			}

			if( ! this.theRecord ) {
				return '';
			}

			return this.theRecord.data?.fields?.Media__c?.value;
		} catch( err ) {
			this.reportError( err );
		}
		return 'No value found';
	}
}