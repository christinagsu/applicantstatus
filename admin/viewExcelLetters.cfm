<cfheader
name="Content-Disposition"
value="attachment; filename=previousletters.xls"
/>

<cfinvoke component="applicantStatusAdmin" method="showSentLetters" />
